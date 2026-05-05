# Python AWS Automation Scripts

This directory contains Python scripts utilizing the `boto3` library to automate interactions with Amazon Web Services (AWS). These scripts demonstrate infrastructure management, cloud resource querying, and programmatic cloud administration.

## Prerequisites

1.  **Python 3.x** must be installed.
2.  Install the required dependencies using pip:
    ```bash
    pip install -r requirements.txt
    ```
3.  **AWS Credentials:** You must have your AWS credentials configured. The scripts use the default credential provider chain (e.g., `~/.aws/credentials`, or environment variables `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY`). Ensure your IAM user has appropriate permissions for S3 and EC2.

## Available Scripts

### 1. `aws_s3_manager.py`
A script to manage Amazon S3 buckets and objects.
- **Features:** Lists all S3 buckets in your account and lists objects within a specified bucket.
- **Usage:** Run the script directly to see a list of buckets. Follow the prompts or modify the `__main__` block to test object listing.
    ```bash
    python aws_s3_manager.py
    ```

### 2. `aws_ec2_manager.py`
A script to report on the status of Amazon EC2 instances.
- **Features:** Retrieves all EC2 instances across specified regions, displaying their Instance ID, State (running, stopped, etc.), Instance Type, and Name tag.
- **Usage:**
    ```bash
    python aws_ec2_manager.py
    ```

## Development Notes
- These scripts use standard Python `logging` to provide informative output.
- Error handling is implemented to gracefully catch common AWS API issues, such as missing credentials or insufficient permissions.
