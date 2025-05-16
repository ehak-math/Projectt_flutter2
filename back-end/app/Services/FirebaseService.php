<?php
namespace App\Services;

use Kreait\Firebase\Factory;
use Kreait\Firebase\Database;

class FirebaseService
{
    protected Database $database;

    public function __construct()
    {
        $factory = (new Factory)
            ->withServiceAccount(storage_path('firebase/firebase_credentials.json'))
            ->withDatabaseUri('https://time-tracking-2b8b9-default-rtdb.asia-southeast1.firebasedatabase.app/');

        $this->database = $factory->createDatabase();
    }

    public function updateSegmentTime(int $raceId, int $participantId, string $segmentName, int $timeInSeconds)
    {
        $ref = "segment_times/{$raceId}/{$participantId}/" . strtolower($segmentName);
        $this->database->getReference($ref)->set($timeInSeconds);
    }
}
