#!/usr/bin/env python3
import boto3
import botocore.exceptions
import logging

logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')
logger = logging.getLogger(__name__)

class EC2Manager:
    def __init__(self, region_name='us-east-1'):
        """Initializes the EC2Manager."""
        try:
            # Using resource for higher-level abstraction where appropriate
            self.ec2_resource = boto3.resource('ec2', region_name=region_name)
            self.region = region_name
        except botocore.exceptions.NoCredentialsError:
            logger.error("AWS credentials not found.")
            raise

    def get_instance_name(self, instance):
        """Helper to extract the 'Name' tag from an EC2 instance."""
        if instance.tags:
            for tag in instance.tags:
                if tag['Key'] == 'Name':
                    return tag['Value']
        return "N/A"

    def list_instances(self):
        """Lists all EC2 instances in the configured region."""
        logger.info(f"Fetching EC2 instances in region: {self.region}")
        try:
            instances = list(self.ec2_resource.instances.all())
            
            if not instances:
                logger.info(f"No EC2 instances found in {self.region}.")
                return

            print(f"{'Instance ID':<20} | {'Name':<25} | {'State':<15} | {'Type':<15}")
            print("-" * 80)
            
            for instance in instances:
                name = self.get_instance_name(instance)
                state = instance.state['Name']
                inst_type = instance.instance_type
                print(f"{instance.id:<20} | {name:<25} | {state:<15} | {inst_type:<15}")

        except botocore.exceptions.ClientError as e:
            logger.error(f"Failed to list EC2 instances: {e}")

if __name__ == "__main__":
    print("--- AWS EC2 Manager ---")
    # You can change the region here
    manager = EC2Manager(region_name='us-east-1')
    manager.list_instances()
