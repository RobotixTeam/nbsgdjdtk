<%@page import="app.app.Conexion"%>
<%@ page import="java.sql.*" %>

<%
    String mensaje = "";
    
    if (request.getMethod().equalsIgnoreCase("post")) {
        // Obt�n los valores ingresados por el usuario desde los campos del formulario
        String correo = request.getParameter("correo");
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        if (correo != null && username != null && password != null) {
            // Crea una instancia de la clase de conexi�n a la base de datos
            Conexion conexion = new Conexion();
            Connection cn = conexion.conectar();

            // Verifica si el correo ya est� registrado
            String checkQuery = "SELECT * FROM administradores WHERE correoAd = ?";
            PreparedStatement checkPst = cn.prepareStatement(checkQuery);
            checkPst.setString(1, correo);
            ResultSet checkRs = checkPst.executeQuery();

            if (checkRs.next()) {
                // El correo ya est� registrado
                mensaje = "El correo ingresado ya est� registrado.";
            } else {
                // El correo no est� registrado, procede con la inserci�n
                // Prepara la sentencia SQL para la inserci�n
                String insertQuery = "INSERT INTO administradores (correoAd, nombreAd, contrase�aAd) VALUES (?, ?, ?)";
                PreparedStatement insertPst = cn.prepareStatement(insertQuery);
                insertPst.setString(1, correo);
                insertPst.setString(2, username);
                insertPst.setString(3, password);

                // Ejecuta la inserci�n en la base de datos
                int filasInsertadas = insertPst.executeUpdate();

                // Verifica si la inserci�n fue exitosa
                if (filasInsertadas > 0) {
                    // La inserci�n fue exitosa
                    mensaje = "Usuario registrado exitosamente.";
                } else {
                    // Ocurri� un error durante la inserci�n
                    mensaje = "Error al registrar el usuario.";
                }

                // Cierra los recursos de inserci�n
                insertPst.close();
            }

            // Cierra los recursos de verificaci�n
            checkRs.close();
            checkPst.close();
            cn.close();
        } else {
            mensaje = "Por favor, completa todos los campos.";
        }
    }
%>

<!DOCTYPE html>
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  <title>Sesion Administradores</title>
  <link rel="stylesheet" href="StyleREAD.css">
  <style>
    .small-button {
      background: none;
      border: none;
      color: black;
      font-size: 12px;
      cursor: pointer;
      text-decoration: none; /* Remove underline */
    }
    
    .small-button:hover {
      color: black; /* Keep the text color black on hover */
      text-decoration: none; /* Remove underline on hover */
    }
  </style>
</head>
<body>
  <div class="container fade-in">
    <h1>Registro</h1>

    <form id="RegistrarForm" method="post">
        
      <label for="email">Correo</label>
      <input type="email" id="correo" name="correo" placeholder="Ingrese su correo" required>
      <label for="username">Usuario</label>
      <input type="text" id="username" name="username" placeholder="Ingresa un usuario" required>
      <label for="password">Contrase�a</label>
      <input type="password" id="password" name="password" placeholder="Ingresa una contrase�a" required>
      <button id="boton" class="boton">Registrar</button>
      
      <button type="button" onclick="goToHomepage()" class="small-button">Regresar al Inicio</button>
    </form>
    
    <% if (!mensaje.isEmpty()) { %>
    <p><%= mensaje %></p>
    <% } %>
  </div>

  <div class="background"></div>

  <script>
    function goToHomepage() {
      window.location.href = "index.html"; // Reemplaza "index.html" con la URL real de la p�gina de inicio
    }
  </script>
</body>
</html>
