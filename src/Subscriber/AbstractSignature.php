<?php

namespace Keboola\GenericExtractor\Subscriber;

use GuzzleHttp\Event\BeforeEvent;
use GuzzleHttp\Event\RequestEvents;
use GuzzleHttp\Message\RequestInterface;

/**
 *
 */
abstract class AbstractSignature
{
    /**
     * @var callable
     */
    protected $generator;

    public function getEvents()
    {
        return ['before' => ['onBefore', RequestEvents::SIGN_REQUEST]];
    }

    public function onBefore(BeforeEvent $event)
    {
        $request = $event->getRequest();

        $this->addSignature($request);
    }

    /**
     * @param RequestInterface $request
     */
    abstract protected function addSignature(RequestInterface $request);

    /**
     * @param callable $generator A method that returns query parameters required for authentication
     */
    public function setSignatureGenerator(callable $generator)
    {
        $this->generator = $generator;
    }

    /**
     * @param RequestInterface $request
     * @return array ['query' => ..., 'request' => ...]
     */
    protected function getRequestAndQuery(RequestInterface $request)
    {
        $query = [];
        foreach ($request->getQuery() as $param => $val) {
            $query[$param] = $val;
        }
        $requestInfo = [
            'url' => $request->getUrl(),
            'path' => $request->getPath(),
            'queryString' => (string) $request->getQuery(),
            'method' => $request->getMethod(),
            'hostname' => $request->getHost(),
            'port' => $request->getPort(),
            'resource' => $request->getResource()
            // if needed, ksorted query string can come here
        ];

        return [
            'query' => $query,
            'request' => $requestInfo
        ];
    }
}
