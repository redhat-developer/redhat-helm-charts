{{- define "infinispan.xml" }}
<infinispan
        xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xsi:schemaLocation="urn:infinispan:config:12.1 https://infinispan.org/schemas/infinispan-config-12.1.xsd
                            urn:infinispan:server:12.1 https://infinispan.org/schemas/infinispan-server-12.1.xsd"
        xmlns="urn:infinispan:config:12.1"
        xmlns:server="urn:infinispan:server:12.1">

   <cache-container name="default" statistics="true">
      <transport cluster="${infinispan.cluster.name:cluster}" stack="kubernetes" node-name="${infinispan.node.name:}"/>
      <security>
         <authorization/>
      </security>
   </cache-container>

   <server xmlns="urn:infinispan:server:12.1">
      <interfaces>
         <interface name="public">
            <inet-address value="${infinispan.bind.address:127.0.0.1}"/>
         </interface>
      </interfaces>

      <socket-bindings default-interface="public" port-offset="${infinispan.socket.binding.port-offset:0}">
         <socket-binding name="default" port="${infinispan.bind.port:11222}"/>
         <socket-binding name="metrics" port="${infinispan.bind.port:11223}"/>
      </socket-bindings>

      <security>
         <credential-stores>
            <credential-store name="credentials" path="credentials.pfx">
               <clear-text-credential clear-text="secret"/>
            </credential-store>
         </credential-stores>
         <security-realms>
            <security-realm name="default">
               {{- if .Values.deploy.security.authentication }}
               <properties-realm groups-attribute="Roles">
                  <user-properties path="users.properties"/>
                  <group-properties path="groups.properties"/>
               </properties-realm>
               {{- end }}
            </security-realm>

            <security-realm name="metrics">
               <properties-realm groups-attribute="Roles">
                   <user-properties path="metrics-users.properties" relative-to="infinispan.server.config.path"
                                    plain-text="true"/>
                   <group-properties path="metrics-groups.properties" relative-to="infinispan.server.config.path"/>
               </properties-realm>
           </security-realm>
         </security-realms>
      </security>

      <endpoints socket-binding="default" security-realm="default"/>

      <!-- Required in order to support BASIC authentication for Servicemetrics -->
      <endpoints socket-binding="metrics" security-realm="metrics">
         <rest-connector>
             <authentication mechanisms="BASIC"/>
         </rest-connector>
     </endpoints>
   </server>
</infinispan>
{{- end }}
