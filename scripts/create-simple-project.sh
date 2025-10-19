# !/bin/bash

project_name=$1

flutter create . --empty --org com.tsitser --project-name $project_name --platforms android,ios,web
echo "Project $project_name created successfully"