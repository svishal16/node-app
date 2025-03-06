#!/bin/bash

git config user.name "svishal16"
git config user.email "shrivastavavishal640@gmail.com"
                    
# Stage changes and commit
git add .
git commit -m "Automated update of certificates via Jenkins"
                    
# Push changes back to GitHub (using HTTPS and the GitHub token)
git push https://${GITHUB_TOKEN}@github.com/svishal16/node-app.git HEAD:main
