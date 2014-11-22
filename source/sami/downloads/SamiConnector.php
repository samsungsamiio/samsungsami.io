<?php
/**
 * SAMI helper class that communicates to SAMI via SAMI PHP SDK
 * */
require_once(dirname(__FILE__) .'/sdk/Swagger.php');
swagger_autoloader('MessagesApi');

class SamiConnector {
    # General Configuration
    const CLIENT_ID = "xxxxx";
    const DEVICE_ID = "xxxxx";
    const API_URL = "https://api.samsungsami.io/v1.1";
 
    # Members
    public $token = null;
    public $apiClient = null; 

    public function __construct(){ }
     
    /**
     * Sets the access token and looks for the user profile information
     */
    public function setAccessToken($someToken){
      $this->token = $someToken;
      $authHeader = 'bearer ' .$this->token;
      $this->apiClient = new APIClient(SamiConnector::CLIENT_ID, SamiConnector::API_URL, $authHeader);
    }
     
    /**
     * GET /historical/normalized/messages/last API
     */
    public function getMessagesLast($srcDeviceId, $countByDevice){
      try {
      	$callAPI = new MessagesApi($this->apiClient);
      	$method = 'getNormalizedMessagesLast';
      	$params = array(
      			"sdids"         => $srcDeviceId,
      			"fieldPresence" => NULL,
      			"count"         => $countByDevice
      	);
      	$result = call_user_func_array(array($callAPI, $method), array_values($params));
      } catch (Exception $e) {
      	$result = '{"getMessageLast_exception":"'.$e->getMessage().'"}';
      }
      return $result;
    }
    
    /**
     * POST /message API
     */
    public function sendMessage($payload){
      try {
    	  $callAPI = new MessagesApi($this->apiClient);
        $method = 'postMessage';
        $params = array(
       		"postParams" => $payload,
          );
        
    	  $result = call_user_func_array(array($callAPI, $method), array_values($params));
    	} catch (Exception $e) {
          $result = "{sendMessage_exception:".$e->getMessage()."}";
    	}
        return $result;
    }
    
}