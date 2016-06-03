# ncloud

Run (replace KEYNAME with your own):
```
aws --profile private --region us-west-2 cloudformation create-stack --stack-name test --template-body file://ncloud.json i--parameters ParameterKey=KeyName,ParameterValue=KEYNAME --capabilities CAPABILITY_IAM
```



