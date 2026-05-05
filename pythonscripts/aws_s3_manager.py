#!/usr/bin/env python3
import boto3
import botocore.exceptions
import logging

# Configure logging
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')
logger = logging.getLogger(__name__)

class S3Manager:
    def __init__(self, region_name='us-east-1'):
        """Initializes the S3Manager with a specific region."""
        try:
            self.s3_client = boto3.client('s3', region_name=region_name)
            self.s3_resource = boto3.resource('s3', region_name=region_name)
        except botocore.exceptions.NoCredentialsError:
            logger.error("AWS credentials not found. Please configure ~/.aws/credentials or environment variables.")
            raise

    def list_buckets(self):
        """Lists all S3 buckets in the AWS account."""
        logger.info("Fetching S3 buckets...")
        try:
            response = self.s3_client.list_buckets()
            buckets = [bucket['Name'] for bucket in response.get('Buckets', [])]
            
            if buckets:
                logger.info(f"Found {len(buckets)} bucket(s):")
                for name in buckets:
                    print(f"  - {name}")
            else:
                logger.info("No S3 buckets found in this account.")
            return buckets
        except botocore.exceptions.ClientError as e:
            logger.error(f"Failed to list buckets: {e}")
            return []

    def list_objects_in_bucket(self, bucket_name, max_keys=10):
        """Lists objects within a specific S3 bucket."""
        logger.info(f"Listing up to {max_keys} objects in bucket: {bucket_name}")
        try:
            # Using paginator is best practice for listing objects
            paginator = self.s3_client.get_paginator('list_objects_v2')
            pages = paginator.paginate(Bucket=bucket_name, PaginationConfig={'MaxItems': max_keys})
            
            count = 0
            for page in pages:
                if 'Contents' in page:
                    for obj in page['Contents']:
                        print(f"  - Key: {obj['Key']}, Size: {obj['Size']} bytes, LastModified: {obj['LastModified']}")
                        count += 1
            if count == 0:
                logger.info(f"Bucket '{bucket_name}' is empty.")
        except botocore.exceptions.ClientError as e:
            error_code = e.response['Error']['Code']
            if error_code == 'NoSuchBucket':
                logger.error(f"Bucket '{bucket_name}' does not exist.")
            elif error_code == 'AccessDenied':
                logger.error(f"Access denied to bucket '{bucket_name}'.")
            else:
                logger.error(f"Failed to list objects in '{bucket_name}': {e}")

if __name__ == "__main__":
    print("--- AWS S3 Manager ---")
    manager = S3Manager()
    
    # 1. List all buckets
    all_buckets = manager.list_buckets()
    
    # 2. If buckets exist, list contents of the first one as an example
    if all_buckets:
        print("\n--- Example: Listing objects in the first bucket ---")
        first_bucket = all_buckets[0]
        manager.list_objects_in_bucket(first_bucket, max_keys=5)
