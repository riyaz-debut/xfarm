. ${PWD}/new-org-scripts/sign-core.sh


# Sign new org config to update channel


if [[ $# -lt 1 ]] ; then
  warnln "Please add org name parameter"
  exit 0
fi

ORG_NAME=$1 

signConfigtxAsPeerOrg  $ORG_NAME 1 ../new-org-config/new_org_update_in_envelope.pb
