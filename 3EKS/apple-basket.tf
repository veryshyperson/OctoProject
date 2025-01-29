resource "kubectl_manifest" "apple_basket_app" {
  depends_on = [ helm_release.argocd ]
  yaml_body = <<YAML
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: apple-basket-app
  namespace: argocd
spec:
  project: default
  source:
    repoURL: https://github.com/veryshyperson/OctoProject
    targetRevision: main
    path: apple-basket
    helm:
      valueFiles:
        - values.yaml
  destination:
    server: https://kubernetes.default.svc
    namespace: default
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
YAML
}
