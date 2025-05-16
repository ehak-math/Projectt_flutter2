<?php

use Illuminate\Support\Facades\Route;
use App\Services\FirebaseService;

Route::get('/', function () {
    return view('welcome');
});

Route::get('/test-firebase', function (FirebaseService $firebaseService) {
    $raceId = 1;
    $participantId = 101;
    $segmentName = 'swim';
    $timeInSeconds = 890; // e.g., 14 min 50 sec

    $firebaseService->updateSegmentTime($raceId, $participantId, $segmentName, $timeInSeconds);

    return 'Firebase updated successfully.';
});
