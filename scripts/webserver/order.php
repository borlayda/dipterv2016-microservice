<?php

if(!isset( $_POST['nameOfBook'], $_POST['numberOfBooks']))
{
    echo 'Please fill Name of Book and Number of Books fields!';
}
else
{
    $name = filter_var($_POST['nameOfBook'], FILTER_SANITIZE_STRING);
    $number = filter_var($_POST['numberOfBooks'], FILTER_SANITIZE_STRING);

    $data = array(
        'nameOfBook' => $name,
        'number'     => $number
    );

    $json = json_encode($data);

    $ch = curl_init();
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($ch, CURLOPT_URL,
        "http://order:8888/order"
    );
    curl_setopt($curl, CURLOPT_HTTPHEADER,
            array("Content-type: application/json"));
    curl_setopt($curl, CURLOPT_POST, true);
    curl_setopt($curl, CURLOPT_POSTFIELDS, $data);
    $output = curl_exec($ch);
    $info = curl_getinfo($ch);
    header("Location: /store.php");
    curl_close($ch);
    die();
}
?>
