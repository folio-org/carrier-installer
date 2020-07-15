docker exec carrier-keycloak /opt/jboss/keycloak/bin/kcadm.sh config credentials --server http://localhost:8080/auth --realm master --user carrier --password carrier \
&& docker exec carrier-keycloak /opt/jboss/keycloak/bin/kcadm.sh update realms/master -s sslRequired=NONE \
&& docker exec carrier-keycloak /opt/jboss/keycloak/bin/kcadm.sh update realms/carrier -s sslRequired=NONE \
&& docker exec carrier-keycloak /opt/jboss/keycloak/bin/kcadm.sh create groups -r carrier -s name=superadmin \
&& groupid=`docker exec carrier-keycloak /opt/jboss/keycloak/bin/kcadm.sh get groups -r carrier | grep id | cut -d: -f2 | sed s/' '//g | sed s/'"'//g | sed s/','//g` \
&& docker exec carrier-keycloak /opt/jboss/keycloak/bin/kcadm.sh update users/8a9a3cec-5e13-42cd-8736-a0e97598d86e/groups/${groupid} -r carrier -s realm=carrier -s userId=8a9a3cec-5e13-42cd-8736-a0e97598d86e -s groupId=${groupid} -n \
&& docker cp /opt/carrier/dev/keycloak/themes/src/main/resources/theme/carrier carrier-keycloak:/opt/jboss/keycloak/themes \
&& docker exec carrier-keycloak /opt/jboss/keycloak/bin/kcadm.sh update realms/carrier -s "loginTheme=carrier"

docker exec carrier-influx bash -c "influx -execute 'create database jmeter'"
docker exec carrier-influx bash -c "influx -execute 'create database comparison'"
docker exec carrier-influx bash -c "influx -execute 'create database gatling'"
docker exec carrier-influx bash -c "influx -execute 'create database prodsec'"
docker exec carrier-influx bash -c "influx -execute 'create database perfui'"
docker exec carrier-influx bash -c "influx -execute 'create database telegraf'"
docker exec carrier-influx bash -c "influx -execute 'create database thresholds'"
docker exec carrier-influx bash -c "influx -execute 'create database profiling'"

# seed grafana datasources
curl -s https://raw.githubusercontent.com/carrier-io/carrier-io/master/influx_datasources/datasource_comparison | curl -X POST "http://localhost/grafana/api/datasources" -u user:user --header "Content-Type: application/json" -d @-
curl -s https://raw.githubusercontent.com/carrier-io/carrier-io/master/influx_datasources/datasource_jmeter | curl -X POST "http://localhost/grafana/api/datasources" -u user:user --header "Content-Type: application/json" -d @-
curl -s https://raw.githubusercontent.com/carrier-io/carrier-io/master/influx_datasources/datasource_gatling | curl -X POST "http://localhost/grafana/api/datasources" -u user:user --header "Content-Type: application/json" -d @-
curl -s https://raw.githubusercontent.com/carrier-io/carrier-io/master/influx_datasources/datasource_prodsec | curl -X POST "http://localhost/grafana/api/datasources" -u user:user --header "Content-Type: application/json" -d @-
curl -s https://raw.githubusercontent.com/carrier-io/carrier-io/master/influx_datasources/datasource_telegraf | curl -X POST "http://localhost/grafana/api/datasources" -u user:user --header "Content-Type: application/json" -d @-
curl -s https://raw.githubusercontent.com/carrier-io/carrier-io/master/influx_datasources/loki | curl -X POST "http://localhost/grafana/api/datasources" -u user:user --header "Content-Type: application/json" -d @-
curl -s https://raw.githubusercontent.com/carrier-io/carrier-io/master/influx_datasources/datasource_thresholds | curl -X POST "http://localhost/grafana/api/datasources" -u user:user --header "Content-Type: application/json" -d @-
curl -s https://raw.githubusercontent.com/carrier-io/carrier-io/master/influx_datasources/datasource_profiling | curl -X POST "http://localhost/grafana/api/datasources" -u user:user --header "Content-Type: application/json" -d @-
curl -s https://raw.githubusercontent.com/carrier-io/carrier-io/master/grafana_dashboards/perfgun_performance_dashboard.json | curl -X POST "http://localhost/grafana/api/dashboards/db" -u user:user --header "Content-Type: application/json" -d @-
curl -s https://raw.githubusercontent.com/carrier-io/carrier-io/master/grafana_dashboards/perfmeter_dashboards.json | curl -X POST "http://localhost/grafana/api/dashboards/db" -u user:user --header "Content-Type: application/json" -d @-
curl -s https://raw.githubusercontent.com/carrier-io/carrier-io/master/grafana_dashboards/telegraph_dashboard.json | curl -X POST "http://localhost/grafana/api/dashboards/db" -u user:user --header "Content-Type: application/json" -d @-
