<?php

namespace Keboola\GenericExtractor\Authentication;

use Bizztreat\Juicer\Client\RestClient;

interface AuthInterface
{
    public function authenticateClient(RestClient $client);
}
