docker run -it --rm -v $PWD:/terraform -v ~/.aws:/root/.aws -w '/terraform' hashicorp/terraform:0.12.21 apply