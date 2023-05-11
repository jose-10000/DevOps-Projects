# access ArgoCD UI


	kubectl get pods  -n argocd

	kubectl port-forward svc/argocd-server 8080:443 -n argocd

# login with admin user and below token (as in documentation):
	kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 --decode && echo
		
	
# you can change and delete init password
