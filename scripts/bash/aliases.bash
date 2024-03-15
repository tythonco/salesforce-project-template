alias sf-list="sf org list"
alias sf-log="sf apex get log --number 1 --output-dir logs"
alias sf-alias="sf alias list"
alias sf-push="sf project deploy start --ignore-conflicts"
alias sf-deploy="sfdx force:source:deploy -p force-app -u chuck.ross@geqfinance.com -l RunLocalTests"
alias scratch="npm run scratch"
alias sf-test="sf apex run test --code-coverage --result-format human --synchronous"
alias sf-def-prod="sfdx force:config:set defaultusername=chuck.ross@geqfinance.com"
alias sf-org="sf config set target-org $1"
alias checkout="npm run checkout"
alias sf-pt="sf-push; sf-test"
alias soql="sf data query --query $1"
alias prod-push="npm run prod-push"
alias swap-org="npm run swap-org"
