<?php

if(!isset( $_POST['username'], $_POST['password']))
{
    echo 'Please enter a valid username and password';
}
else
{
    $username = filter_var($_POST['username'], FILTER_SANITIZE_STRING);
    $password = filter_var($_POST['password'], FILTER_SANITIZE_STRING);

    $ch = curl_init();
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($ch, CURLOPT_URL,
        "http://auth:8081/auth/{$username}/{$password}"
    );
    $output = curl_exec($ch);
    $info = curl_getinfo($ch);
    if ($output === false || $info['http_code'] != 200) {
        $output = "No cURL data returned for $url [". $info['http_code']. "]";
        if (curl_error($ch))
            $output .= "\n". curl_error($ch);
    }
    else { 
        header("Location: /store.php");
        die();
    }
    curl_close($ch);
}
?>
