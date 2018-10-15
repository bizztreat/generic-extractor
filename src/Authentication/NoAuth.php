<?php
namespace Keboola\GenericExtractor\Authentication;

use Bizztreat\Juicer\Client\RestClient;

class NoAuth implements AuthInterface
{
    /**
     * @param RestClient $client
     */
    public function authenticateClient(RestClient $client)
    {
    }
}
