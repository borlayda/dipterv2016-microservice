<html>
<head>
<title>Bookstore Microservice</title>
</head>
<body>

<h2>Books:</h2>

<table>
  <tbody>
    <th>Name</th><th>Quantity</th>
    <?php
    $mysql_hostname = 'database';
    $mysql_username = 'root';
    $mysql_password = '';
    $mysql_dbname = 'bookstore';

    try
    {
        $dbh = new PDO("mysql:host=$mysql_hostname;dbname=$mysql_dbname", $mysql_username, $mysql_password);
        $dbh->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
        $result = $dbh->query("SELECT store_id, book_name, count FROM store");

        if ($result->num_rows > 0) {
            // output data of each row
            while($row = $result->fetch_assoc()) {
                echo "<tr><td>" . $row["book_name"]. "</td><td>" . $row["count"]. "</td></tr>";
            }
        } else {
            echo "No results";
        }


    }
    catch(Exception $e)
    {
        $message = 'We are unable to process your request. Please try again later"';
    } 
    ?>
  </tbody>
</table>

</body>
</html>