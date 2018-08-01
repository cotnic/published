package com.cotnic.server;

import com.cotnic.model.ClientModel;
import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;
import com.sun.net.httpserver.HttpServer;

import java.io.IOException;
import java.io.OutputStream;
import java.net.InetSocketAddress;
import java.util.HashMap;
import java.util.Map;

public class DoServer {

    private static Map<String, ClientModel> clients = new HashMap();

    public static void main(String[] args) throws Exception {
        HttpServer server = HttpServer.create(new InetSocketAddress(8080), 0);
        server.createContext("/", new DoSHandler());
        server.setExecutor(null);
        server.start();
        System.out.println("Server is up and running.");
    }

    public static boolean checkClientMaxReq(String query) {
        Map<String, String> parameters = splitingQuery(query);
        if (clients.containsKey(parameters.get("clientId"))) {
            if ((System.currentTimeMillis() - clients.get(parameters.get("clientId")).getFirstAcces()) > 15) {
                clients.put(parameters.get("clientId"), new ClientModel(parameters.get("clientId"), 1, System.currentTimeMillis()));
            } else {
                ClientModel clientModel = clients.get(parameters.get("clientId"));
                clientModel.setCounter(clientModel.getCounter() + 1);
            }
            if (clients.get(parameters.get("clientId")).getCounter() > 5)
                return false;
        } else {
            clients.put(parameters.get("clientId"), new ClientModel(parameters.get("clientId"), 1, System.currentTimeMillis()));
        }
        System.out.println("Number of requests for userid: " + parameters.get("clientId") + " is: " + clients.get(parameters.get("clientId")));
        return true;
    }

    private static Map splitingQuery(String query) {
        String param[] = query.split("&"); // token=123 | clientId=3
        if (param.length == 1)
            return null;
        Map<String, String> parameters = new HashMap<String, String>();
        for (int i = 0; i < param.length; i++) {
            String[] split = param[i].split("=");
            parameters.put(split[0], split[1]);
        }

        return parameters;
    }

    static class DoSHandler implements HttpHandler {

        public void handle(HttpExchange t) throws IOException {
            String response = "Response";
            if (checkClientMaxReq(t.getRequestURI().getQuery()))
                t.sendResponseHeaders(200, response.length());
            else
                t.sendResponseHeaders(503, response.length());
            OutputStream os = t.getResponseBody();
            os.write(response.getBytes());
            os.close();
        }
    }
}
