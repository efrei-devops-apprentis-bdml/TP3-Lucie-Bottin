### Lucie Bottin M1-APP-BDIA
# TP3 Devops


#### Construction de la solution

Nous allons utiliser les GitHub Actions afin de déployer notre API dans le cloud Azure. 

##### Etape 1 : Création de l'API

Nous avons utilisé le framework Flask pour déployer le code. Toutes les variables d'environnements (lat, long, api_key) sont passées en paramètres et récupérées depuis la commande user. 

##### Etape 2 : Dockerfile

Ce fichier permet donc d'installer les librairies nécessaires et lancer le fichier main.py qui contient l'API

##### Etape 3 : Build Docker

Une fois que notre développement est terminé, on build notre code avec la commande :
```
docker build . -t efrei-tp3:0.0.1
```
Ensuite ajouter le tag de l'image pour la publier :
```
docker tag efrei-tp3:0.0.1 luciebottin/efrei-tp3:0.0.1
```
Pour finir on push l'image pour la publier dans le container :
```
docker push luciebottin/efrei-tp3:0.0.1
```

##### Etape 5 : GitHub Actions

Lorsque l'on commit de nouveau notre code, nous aimerions que tous se mette à jour et que ce soit push dans Azure. 
La première step est de log dans Azure :
```
azure/login@v1
```
Les credentials ne sont pas en brut dans le code, pour une question de sécurité nous allons utiliser les secrets de github. Une fois les secrets mis en place, on les insère dans le code :
```
${{ secrets.AZURE_CREDENTIALS }}
```
Ensuite on push et on build la nouvelle image docker :
```
azure/docker-login@v1
```
Pareil, pour se connecter dans GitHub on utilise les secrets pour cacher notre username et password
```
login-server: ${{ secrets.REGISTRY_LOGIN_SERVER }}
username: ${{ secrets.REGISTRY_USERNAME }}
password: ${{ secrets.REGISTRY_PASSWORD }}
```
On peut build l'image dans docker, puis la push
```
docker build . -t ${{ secrets.REGISTRY_LOGIN_SERVER }}/20180304:v1
```
Il est temps de déployer notre image en tant qu'instance de conteneur dans Azure :
```
'azure/aci-deploy@v1'
```
Tous les identifiants, groupe de ressource, api key, sont contenus dans des secrets.
A la fin on ajoute seulement les paramètres manquants :
```
name: "20180304"
ports: 80
location: 'france central'
```
Le port doit être celui présent dans le fichier python
```
app.run(host='0.0.0.0',debug=True,port=80)
```
Notre image au format API est maintenant mise à disposition sur Azure Container Registry en utilisant les GitHub Actions. 

Afin de lancer le code qui est dans Azure, il suffit d'utiliser la commande suivante :
```
curl "http://devops-20180304.francecentral.azurecontainer.io/?lat=5.902785&lon=102.754175"
```

##### Etape 6 : Publier le code dans github

Afin que le code pur soit accessible, on push notre code dans un répertoire GitHub publique.

#### Voici les URLs :

Image Docker : https://hub.docker.com/repository/docker/luciebottin/efrei-tp3
Repo GitHub : https://github.com/efrei-devops-apprentis-bdml/TP3-Lucie-Bottin
Image Azure : efreidevops.azurecr.io/20180304:v1
