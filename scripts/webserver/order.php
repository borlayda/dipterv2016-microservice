<?php

if(!isset( $_POST['nameOfBook'], $_POST['numberOfBooks']) || $_POST['numberOfBooks'] == "" || $_POST['nameOfBook'] == "")
{
    echo 'Please fill Name of Book and Number of Books fields!';
    sleep(10);
    header("Location: /store.php");
    die();
}
else
{
    echo "<br/>Getting parameters for request ...<br/>";
    $name = filter_var($_POST['nameOfBook'], FILTER_SANITIZE_STRING);
    $number = filter_var($_POST['numberOfBooks'], FILTER_SANITIZE_STRING);
    echo "<br/>Sending request for with your order ...<br/>";
    $url = 'http://order:8888/order/order';
    $data = array(
        'nameOfBook' => $name,
        'number'     => $number
    );

    $ch = curl_init();

    curl_setopt($ch, CURLOPT_URL, $url);
    curl_setopt($ch, CURLOPT_POST, 1);
    curl_setopt($ch, CURLOPT_POSTFIELDS,
                http_build_query($data));
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    $server_output = curl_exec ($ch);
    curl_close ($ch);

    // further processing ....
    if ($server_output == "OK") {
        echo "Failed to send request";
    } else {
        $info = curl_getinfo($ch);
        echo "<br/>Order proceeded, redirect to store page ...<br/>";
        header("Location: /store.php");
        curl_close($ch);
        die();
    }

}
?>
