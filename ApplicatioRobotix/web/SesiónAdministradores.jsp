<%@page import="app.app.Conexion"%>
<%@page import="java.sql.*"%>
<!DOCTYPE html>
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  <title>Sesion Administradores</title>
  <link rel="stylesheet" href="StyleSEAD.css">
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
<%
    String mensaje = "";
    
    if (request.getMethod().equalsIgnoreCase("post")) {
        // Obt�n los valores ingresados por el usuario desde los campos del formulario
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        if (username != null && password != null) {
            // Crea una instancia de la clase de conexi�n a la base de datos
            Conexion conexion = new Conexion();
            Connection cn = conexion.conectar();

            // Prepara la sentencia SQL para verificar las credenciales de inicio de sesi�n
            String query = "SELECT * FROM administradores WHERE nombreAd = ? AND contrase�aAd = ?";
            PreparedStatement pst = cn.prepareStatement(query);
            pst.setString(1, username);
            pst.setString(2, password);

            // Ejecuta la consulta en la base de datos
            ResultSet rs = pst.executeQuery();

            // Verifica si se encontraron resultados en la consulta
            if (rs.next()) {
                // Inicio de sesi�n exitoso
                mensaje = "Inicio de sesi�n exitoso. Redireccionando...";
                response.sendRedirect("BajaAltasA.jsp");
                
            } else {
                // Inicio de sesi�n fallido
                mensaje = "Nombre de usuario o contrase�a incorrectos.";
            }

            // Cierra los recursos
            rs.close();
            pst.close();
            cn.close();
        } else {
            mensaje = "Por favor, ingresa el nombre de usuario y contrase�a.";
        }
    }
%>

  <div class="container fade-in">
    <h1>Iniciar Sesi�n</h1>

    <form id="loginForm" method="post">
      <label for="nombre">Nombre</label>
      <input type="text" id="username" name="username" placeholder="Ingresa tu nombre" required>
      <label for="password">Contrase�a</label>
      <input type="password" id="password" name="password" placeholder="Ingresa tu contrase�a" required>
      <button id="boton" class="boton">Iniciar Sesi�n</button>
      <button type="button" onclick="registroAd()" class="boton2">Registro</button>
      <button type="button" onclick="goToHomepage()" class="small-button">Regresar al Inicio</button>
    </form>
  </div>

  <div class="background"></div>

<% if (!mensaje.isEmpty()) { %>
    <script>
        alert("<%= mensaje %>");
    </script>
<% } %>

  <script>
    function registroAd() {
      window.location.href = "RegistroAdministradores.jsp";
    }

    function goToHomepage() {
      window.location.href = "index.html"; // Reemplaza "index.html" con la URL real de la p�gina de inicio
    }
  </script>
</body>
</html>
