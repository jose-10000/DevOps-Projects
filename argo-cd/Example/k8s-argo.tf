resource "kubernetes_namespace" "argocd" {
  metadata {
    name = "argocd"
  }
}


resource "null_resource" "argocd" {
  depends_on = [
    kubernetes_namespace.argocd
  ]
  provisioner "local-exec" {
    command = "minikube kubectl -- apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml" 
  }
}