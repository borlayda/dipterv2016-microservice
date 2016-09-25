<html>
<head>
<title>Bookstore Microservice</title>
</head>
<body>

<h2>Books:</h2>

<table>
  <tbody>
    <tr><th>Name</th><th>Quantity</th></tr>

    <?php
      $servername = "database";
      $username = "store";
      $password = "store";
      $dbname = "bookstore";

      // Create connection
      $conn = new mysqli($servername, $username, $password, $dbname);
      // Check connection
      if ($conn->connect_error) {
          die("Connection failed: " . $conn->connect_error);
      }

      $sql = "SELECT * FROM store";
      $result = $conn->query($sql);

      if ($result->num_rows > 0) {
          // output data of each row
          while($row = $result->fetch_assoc()) {
              echo "<tr><td>" . $row["book_name"]. "</td><td> " . $row["count"]. "</td></tr>";
          }
      } else {
          echo "0 results";
      }
      $conn->close();
    ?>

  </tbody>
</table>

<form action="reserve.php">
    <span>Name of Book: </span><input type="text" name="nameOfBook" /><br/>
    <span>Number of Books: </span><input type="text" name="numberOfBooks"/><br/>
    <input type="submit" name="send">Send</input>
</form>


</body>
</html>
