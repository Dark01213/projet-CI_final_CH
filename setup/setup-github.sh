#!/bin/bash

# Initialize GitHub Repository

echo "╔════════════════════════════════════════════════╗"
echo "║  GitHub Repository Initialization             ║"
echo "╚════════════════════════════════════════════════╝"
echo ""

# Initialize git if not already
if [ ! -d .git ]; then
    echo "Initializing git repository..."
    git init
    echo "✓ Git repository initialized"
else
    echo "✓ Git repository already exists"
fi

echo ""
echo "Setting up git configuration..."

# Configure git user (optional)
read -p "Enter your name (for git commits): " git_name
read -p "Enter your email (for git commits): " git_email

git config user.name "$git_name"
git config user.email "$git_email"

echo "✓ Git configured with name: $git_name, email: $git_email"

echo ""
echo "Creating initial commits..."

# Add all files
git add .

# Create initial commit
git commit -m "Initial commit: Task Management Application with CI/CD and Kubernetes"

echo "✓ Initial commit created"

echo ""
echo "╔════════════════════════════════════════════════╗"
echo "║  Next Steps:                                   ║"
echo "╚════════════════════════════════════════════════╝"
echo ""
echo "1. Create repository on GitHub:"
echo "   - Go to https://github.com/new"
echo "   - Create repository named: app-automation"
echo "   - Do NOT initialize with README (we have one)"
echo ""
echo "2. Add remote and push:"
echo "   git remote add origin https://github.com/YOUR-USERNAME/app-automation.git"
echo "   git branch -M main"
echo "   git push -u origin main"
echo ""
echo "3. Configure GitHub Secrets:"
echo "   - Go to: Settings > Secrets and variables > Actions"
echo "   - Add the following secrets:"
echo ""
echo "   Secret Name: VM_HOST"
echo "   Value: (IP from terraform output)"
echo ""
echo "   Secret Name: VM_USERNAME"
echo "   Value: azureuser"
echo ""
echo "   Secret Name: VM_SSH_KEY"
echo "   Value: (Content of ~/.ssh/id_rsa - PRIVATE KEY)"
echo ""
echo "4. Enable GitHub Actions:"
echo "   - Go to: Actions tab"
echo "   - Review the workflow file"
echo "   - Click 'Enable workflow' if needed"
echo ""
echo "5. Deploy Azure infrastructure:"
echo "   bash scripts/deploy-azure.sh"
echo ""
echo "6. Update VM_HOST secret after Azure deployment"
echo ""
echo "That's it! Your CI/CD pipeline is ready!"
