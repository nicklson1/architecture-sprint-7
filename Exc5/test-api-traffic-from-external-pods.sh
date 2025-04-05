#!/bin/bash

test_api() {
    TO=$1
    echo "Test API request from random external pod to $TO"

    kubectl run test-$RANDOM --rm -i -t --image=alpine -- sh \
        -c "wget -qO- --timeout=2 http://$TO"
}

echo "Should NOT be allowed"
test_api "front-end-app" 
test_api "back-end-api-app"
test_api "admin-front-end-app" 
test_api "admin-back-end-api-app"
