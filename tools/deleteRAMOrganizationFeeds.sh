#!/usr/bin/env bash

# Copyright 2020 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the 'License');
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an 'AS IS' BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Main
projectID="to_be_adapted"
organizationIDs=("to_be_adapted" "to_be_adapted")

for organizationID in "${organizationIDs[@]}"
do
    existingFeedList=`gcloud asset feeds list --organization=$organizationID --format="value(feeds.name)"`
    IFS=';' read -r -a existingFeedArray <<< "$existingFeedList"
    for feedPath in "${existingFeedArray[@]}"
    do
        IFS='/' read -r -a feedPathArray <<< "$feedPath"
        feed=${feedPathArray[-1]}
        topicPath=`gcloud asset feeds describe $feed --organization=$organizationID --format="value(feedOutputConfig.pubsubDestination.topic)"`
        if [[ $topicPath == "projects/$projectID/topics/"* ]]
        then
            echo "delete: $feedPath linked to $topicPath"
            gcloud asset feeds delete $feed --organization=$organizationID
        else
            echo "keep: $feedPath linked to $topicPath"
        fi
    done
done
#END