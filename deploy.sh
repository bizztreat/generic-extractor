#!/bin/bash
set -e

docker images
docker pull quay.io/keboola/developer-portal-cli-v2:latest

echo "image pulled"

export REPOSITORY=`docker run --rm  \
    -e KBC_DEVELOPERPORTAL_USERNAME -e KBC_DEVELOPERPORTAL_PASSWORD -e KBC_DEVELOPERPORTAL_URL \
    quay.io/keboola/developer-portal-cli-v2:latest ecr:get-repository ${KBC_DEVELOPERPORTAL_VENDOR} ${KBC_DEVELOPERPORTAL_APP}`

eval $(docker run --rm \
    -e KBC_DEVELOPERPORTAL_USERNAME -e KBC_DEVELOPERPORTAL_PASSWORD -e KBC_DEVELOPERPORTAL_URL \
    quay.io/keboola/developer-portal-cli-v2:latest ecr:get-login ${KBC_DEVELOPERPORTAL_VENDOR} ${KBC_DEVELOPERPORTAL_APP})

echo "Pushing to the repository"	
# Push to the repository
docker tag ${APP_IMAGE}:latest ${REPOSITORY}:${TRAVIS_TAG}
docker tag ${APP_IMAGE}:latest ${REPOSITORY}:latest
docker push ${REPOSITORY}:${TRAVIS_TAG}
docker push ${REPOSITORY}:latest


echo "Updating KBC component version"
# Update the tag in Keboola Developer Portal -> Deploy to KBC
if echo ${TRAVIS_TAG} | grep -c '^v\?[0-9]\+\.[0-9]\+\.[0-9]\+$'
then
    docker run --rm \
        -e KBC_DEVELOPERPORTAL_USERNAME \
        -e KBC_DEVELOPERPORTAL_PASSWORD \
        quay.io/keboola/developer-portal-cli-v2:latest \
        update-app-repository ${KBC_DEVELOPERPORTAL_VENDOR} ${KBC_DEVELOPERPORTAL_APP} ${TRAVIS_TAG} ecr ${REPOSITORY}
else
    echo "Skipping deployment to KBC, tag ${TRAVIS_TAG} is not allowed."
fi

	
	

# Update templated components using generic image
#declare -a components=(
#    "ex-adform"
#    "ex-impactradius"
#    "keboola.ex-babelforce"
#    "keboola.ex-flexibee"
#    "keboola.ex-gcalendar"
#    "keboola.ex-hubspot"
#    "keboola.ex-intercom-v2"
#    "keboola.ex-mailchimp"
#    "keboola.ex-mediamath"
#    "keboola.ex-pingdom"
#    "keboola.ex-pipedrive"
#    "keboola.ex-portadi"
#    "keboola.ex-github"
#    "keboola.ex-slack"
#    "keboola.ex-stripe"
#    "keboola.ex-telfa"
#    "keboola.ex-zendesk"
#)
#
#for component in "${components[@]}"
#do
#   docker run --rm -e KBC_DEVELOPERPORTAL_USERNAME -e KBC_DEVELOPERPORTAL_PASSWORD -e KBC_DEVELOPERPORTAL_URL \
#       quay.io/keboola/developer-portal-cli-v2:latest update-app-repository --configuration-format=json \
#       ${KBC_DEVELOPERPORTAL_VENDOR} ${component} ${TRAVIS_TAG} \
#       ecr ${REPOSITORY}
#done

