# Kubernetes Configuration

Configuration for kubectl, k9s, and Krew plugin manager.

## Features

### Tools
- **kubectl** - Kubernetes CLI
- **k9s** - Interactive TUI for Kubernetes
- **Krew** - Kubectl plugin manager
- **kubectx** - Fast context switching
- **kubens** - Fast namespace switching

### kubectl Aliases
- **k** - kubectl alias
- **kc** - kubectl alias
- **kgp** - Get pods
- **kgs** - Get services
- **kgd** - Get deployments
- **kdp** - Describe pod
- **kl** - Logs
- **ke** - Exec into pod
- **ka** - Apply
- **kd** - Delete

### k9s Features
- **Dracula theme** - Beautiful dark theme
- **Interactive** - TUI for Kubernetes
- **Real-time** - Live updates
- **Logs** - View logs
- - **Shell** - Exec into pods
- - **Port forward** - Port forward services
- - **YAML** - View and edit YAML

### Krew Plugins
- **kubectx** - Fast context switching
- **kubens** - Fast namespace switching
- **kubectl-get-all** - Get all resources
- **kubectl-tree** - Resource tree view
- **kubectl-open** - Open in browser
- **kubectl-shell** - Shell into pod
- **kubectl-sudo** - Run as root
- **kubectl-debug** - Debug pods

## Installation

### Prerequisites

```bash
# Install kubectl
# macOS
brew install kubectl

# Fedora
sudo dnf install kubectl

# Ubuntu
sudo apt install kubectl

# Arch
sudo pacman -S kubectl

# Install k9s
# macOS
brew install k9s

# Fedora
sudo dnf install k9s

# Ubuntu
sudo snap install k9s

# Arch
sudo pacman -S k9s

# Install Krew
# Follow instructions at:
# https://krew.sigs.k8s.io/

# macOS/Linux:
# 1. Download krew
# 2. Install krew
# 3. Update PATH
```

### Setup

```bash
# Copy k9s config
mkdir -p ~/.config/k9s
cp ~/.local/share/greg-config/containers/kubernetes/base/config.yaml ~/.config/k9s/

# Copy kubectl config (if needed)
# Kubernetes config is usually in ~/.kube/config
# The gh config includes kubectl aliases

# Enable shell completion
# For bash:
echo "source <(kubectl completion bash)" >> ~/.bashrc
source <(kubectl completion bash)

# For zsh:
echo "source <(kubectl completion zsh)" >> ~/.zshrc
source <(kubectl completion zsh)

# For fish:
kubectl completion fish | source

# Start k9s
k9s
```

## Usage

### kubectl Commands

```bash
# Context management
kubectl config get-contexts           # List contexts
kubectl config current-context           # Current context
kubectl config use-context my-cluster    # Switch context
kubectl config delete-context my-cluster # Delete context

# Namespace management
kubectl get namespaces                  # List namespaces
kubectl config set-context --current --namespace=default
kubens default                         # Switch namespace (kubens plugin)

# Get resources
kubectl get pods                         # List pods
kubectl get services                     # List services
kubectl get deployments                 # List deployments
kubectl get all                          # Get all resources
kubectl get-all                          # Get all resources (krew plugin)

# Describe resources
kubectl describe pod/my-pod
kubectl describe deployment/my-deployment

# Logs
kubectl logs my-pod                     # Container logs
kubectl logs -f my-pod                   # Follow logs
kubectl logs --previous my-pod          # Previous logs

# Exec
kubectl exec -it my-pod -- /bin/bash    # Exec into pod
kubectl exec -it my-pod -- sh           # Exec with sh
kubectl ssh my-pod                       # SSH plugin

# Scale
kubectl scale deployment/my-deployment --replicas=3

# Port forward
kubectl port-forward svc/my-service 8080:80

# Apply
kubectl apply -f deployment.yaml
kubectl apply -f directory/

# Delete
kubectl delete -f deployment.yaml
kubectl delete pod my-pod

# Edit
kubectl edit deployment my-deployment
kubectl edit svc my-service
```

### k9s Commands

```bash
# Start k9s
k9s

# Specify context
k9s --context my-context

# Specify namespace
k9s -n my-namespace

# Navigate
h/j/k/l      # Move left/down/up/right
:            # Command mode
/            # Search
?            # Help
q            # Quit

# Keybindings
Ctrl-h       # Previous split
Ctrl-j       # Down
Ctrl-k       # Up
Ctrl-l       # Next
Ctrl-u       # Half page up
Ctrl-d       # Half page down
gg           # Top
G            # Bottom

# Views
:a           # All
:x           # Pods
/:           # Services
:d           # Deployments
:n           # Namespaces
:l           # Logs
:t           # Containers

# Actions
enter        # View resource
e            # Edit resource
y            # YAML view
ctrl-d       # Delete
ctrl-s       # Scale
l            # Logs
s            # Shell
f            # Port forward
```

### Kubectx

```bash
# List contexts
kubectx

# Switch context
kubectx my-cluster

# Switch context and namespace
kubectx my-cluster --namespace default

# Rename context
kubectx my-cluster new-name

# Delete context
kubectx -d my-cluster
```

### Kubens

```bash
# List namespaces
kubens

# Switch namespace
kubens kube-system

# Go to previous namespace
kubens -

# Set default namespace for context
kubens default --context my-context
```

## k9s Views

### All Resources
- **Context** - Show current context
- **Cluster** - Show cluster info
- **Pods** - List pods
- **Deployments** - List deployments
- **Services** - List services
- **ConfigMaps** - List ConfigMaps
- **Secrets** - List secrets
- **CRDs** - Custom resources

### Logs View
- **Follow** - Follow logs
- **Previous** - Previous logs
- **Container** - Select container
- **Timestamp** - Show timestamps

### Containers
- **List** - List containers
- **Shell** - Exec into container
- **Logs** - View container logs

## Configuration

### k9s Skin (Dracula)

```yaml
skin:
  default:
    fg: "#f8f8f2"
    bg: "#282a36"
    selected:
      fg: "#282a36"
      bg: "#bd93f9"
```

### k9s Views

```yaml
views:
  yaml:
    fg: "#8be9fd"
    bg: "#282a36"
  logs:
    fg: "#f8f8f2"
    bg: "#282a36"
```

## kubectl Aliases

### Quick Aliases

```bash
# General
alias k=kubectl
alias kc=kubectl

# Context
alias kctx=kubectl config use-context
alias kcur=kubectl config current-context
alias kctxs=kubectl config get-contexts

# Namespace
alias kns=kubectl config set-context --current --namespace
alias kn=kubectl config view --minify -o jsonpath='{..namespace}'

# Get
alias kgp=kubectl get pods
alias kgs=kubectl get services
alias kgd=kubectl get deployments
alias kgsec=kubectl get secrets
alias kgcm=kubectl get configmaps

# Describe
alias kdp=kubectl describe pod
alias kds=kubectl describe service
alias kdd=kubectl describe deployment

# Logs
alias kl=kubectl logs
alias klf=kubectl logs -f

# Exec
alias ke=kubectl exec -it

# Apply
alias ka=kubectl apply -f

# Delete
alias kd=kubectl delete -f
```

## Tips

### Quick Pod Access

```bash
# Interactive pod selector
kubectl get pod

# Exec into pod
kubectl exec -it <pod-name> -- sh

# View logs
kubectl logs -f <pod-name>

# Delete pod
kubectl delete pod <pod-name>
```

### Namespace Switching

```bash
# Use kubens for fast namespace switching
kubens

# Switch to kube-system
kubens kube-system

# Go back
kubens -
```

### Context Switching

```bash
# Use kubectx for fast context switching
kubectx

# Switch to production
kubectx production

# Switch to staging
kubectx staging
```

### Port Forwarding

```bash
# Port forward service
kubectl port-forward svc/my-service 8080:80

# Port forward pod
kubectl port-forward pod/my-pod 8080:80

# Background port forward
kubectl port-forward svc/my-service 8080:80 &
```

### Debugging

```bash
# Describe pod
kubectl describe pod/my-pod

# Get events
kubectl get events --sort-by='.lastTimestamp'

# View pod logs
kubectl logs my-pod

# View previous logs
kubectl logs my-pod --previous

# Check resources
kubectl top nodes
kubectl top pods
```

## Troubleshooting

### k9s not connecting

1. Check kubeconfig: `kubectl config view`
2. Check context: `kubectl config current-context`
3. Check cluster access: `kubectl cluster-info`

### Krew not working

```bash
# Verify Krew installation
kubectl krew version

# Check Krew plugins
kubectl krew list

# Update PATH
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
```

### kubectl commands not working

```bash
# Check kubectl version
kubectl version --client

# Check cluster access
kubectl cluster-info

# Check config
kubectl config view
```

## Resources

- [kubectl Documentation](https://kubernetes.io/docs/reference/kubectl/)
- [k9s Documentation](https://k9scli.io/)
- [Krew Documentation](https://krew.sigs.k8s.io/)
- [Dracula Theme](https://draculatheme.com/)

---

**Last Updated**: 2025-03-14
