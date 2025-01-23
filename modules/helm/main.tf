
resource "helm_release" "nginx-ingress-controller" {
  name             = "ingress-nginx"
  repository       = "https://kubernetes.github.io/ingress-nginx"
  chart            = "ingress-nginx"
  namespace        = "kube-system"
  create_namespace = true
  # on EKS this setting will create a classic load balancer
  values = [file("${path.module}/chart-values/nginx-ingress-controller-values.yaml")]
}


resource "helm_release" "aws-alb-ingress-controller" {
  name             = "ingress-alb"
  repository       = "https://aws.github.io/eks-charts"
  chart            = "aws-load-balancer-controller"
  namespace        = "kube-system"
  create_namespace = true
  set = [{
    name  = "clusterName"
    value = var.cluster_name
    }, {
    name  = "enableServiceMutatorWebhook"
    value = "false"
    }
  ]

}

resource "helm_release" "prometheus" {
  name             = "prometheus"
  repository       = "https://prometheus-community.github.io/helm-charts"
  chart            = "prometheus"
  namespace        = "monitoring"
  create_namespace = true
  values           = [file("${path.module}/chart-values/prometheus-values.yaml")]


  depends_on = [helm_release.nginx-ingress-controller, helm_release.aws-alb-ingress-controller]



}


resource "helm_release" "grafana" {
  name             = "grafana"
  repository       = "https://grafana.github.io/helm-charts"
  chart            = "grafana"
  namespace        = "monitoring"
  create_namespace = true
  values = [templatefile("${path.module}/chart-values/grafana-values.yaml", {
    default_region = var.region
  })]

  depends_on = [helm_release.nginx-ingress-controller, helm_release.aws-alb-ingress-controller]


}
