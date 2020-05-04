FROM amazonlinux

RUN yum install -y unzip tar
RUN yum install -y shadow-utils
RUN adduser -m ec2-user --uid=1000 && echo "ec2-user:pwd" | chpasswd
RUN mkdir -p /home/ec2-user/SageMaker
RUN chown -R ec2-user:ec2-user /home/ec2-user/SageMaker

ADD . /better-sagemaker

ENTRYPOINT ["bash", "/better-sagemaker/test.sh"]
