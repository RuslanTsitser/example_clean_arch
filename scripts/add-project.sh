# !/bin/bash

project_name=$1

mkdir -p monorepo/apps/$project_name
cd monorepo/apps/$project_name
flutter create . --empty --org com.tsitser --project-name $project_name --platforms android,ios,web
echo "Project $project_name created successfully"
cd ../../..

# TODO:
# ```apps/$project_name pubspec.yaml
# ... # other dependencies
# resolution: workspace
# ```

# ```root pubspec.yaml
# workspace:
#   ... # other projects
#   - apps/$project_name
# ```
