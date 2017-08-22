<?php
//  Copyright (c) 2017, BuyByMarcus Ltd. All rights reserved. Use of this source code
//  is governed by a BSD-style license that can be found in the LICENSE file.

header('Accept-Charset: UTF-8');
header('Access-Control-Allow-Methods: DELETE, GET, POST, PUT');
header('Content-Type: application/json; charset=utf-8');
$http_origin = $_SERVER["HTTP_ORIGIN"];

if ($http_origin === "http://localhost:63342" || $http_origin === "https://sandbox.bokain.se" || $http_origin === "http://sandbox.bokain.se")
{
	header("Access-Control-Allow-Origin: $http_origin");
}
 
/// REMOVE IN PRODUCTION ///
ini_set('display_errors', 1);
error_reporting(E_ALL);
////////////////////////////

$request = explode('/', trim($_SERVER['PATH_INFO'], '/'));
$system = preg_replace('/[^a-z0-9_]+/i','',array_shift($request));
$key = array_shift($request);

$input = json_decode(file_get_contents('php://input'), true);

if (isset($system))
{
	if (!file_exists(__DIR__ . '/../subsystem.bokain.se/system/' . $system . '.php'))
	{
		http_response_code(404);
		echo "Subsystem '$system' not found";
		//print_r(json_encode($response));
	}
	else
	{
		require_once(__DIR__ . '/../subsystem.bokain.se/system/' . $system . '.php');
		$subsystem = new $system();
	
		try
		{
			print_r(json_encode($subsystem->call($key, $input)));
		}
		catch (Exception $e)
		{
			if (http_response_code() === 200) http_response_code(400);
			echo $e->getMessage();
		}
	}
}
