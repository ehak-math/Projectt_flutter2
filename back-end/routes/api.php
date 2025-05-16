<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\RaceController;
use App\Http\Controllers\ParticipantController;
use App\Http\Controllers\TrackingController;
use App\Http\Controllers\SegmentController;
use App\Models\Segment;

// Route::get('/user', function (Request $request) {
//     return $request->user();
// })->middleware('auth:sanctum');


Route::post('/register', [AuthController::class, 'register']);
Route::post('/login', [AuthController::class, 'login']);

Route::middleware(['auth:sanctum'])->group(function () {

    // RACE MANAGER ROUTES
    Route::middleware('role:race_manager')->group(function () {
        Route::apiResource('participants', ParticipantController::class);
        Route::get('/participants/bib/{bib}', [ParticipantController::class, 'findByBib']);
        Route::apiResource('segments', SegmentController::class);
        Route::post('races/{race}/start', [RaceController::class, 'start']);
        Route::post('races/{race}/finish', [RaceController::class, 'finish']);
        Route::post('races/{race}/reset', [RaceController::class, 'reset']);
        Route::get('races/{race}/results', [RaceController::class, 'results']);
        Route::get('races/{race}/segments', [RaceController::class, 'segments']);
        Route::get('races/{race}/participants', [RaceController::class, 'participants']);
        Route::apiResource('races', RaceController::class);
    });

    // TIME TRACKER ROUTES
    Route::middleware('role:time_tracker')->group(function () {
        Route::get('races-tracker', [RaceController::class, 'index']);
        Route::get('races/{race}/segment-tracker', [RaceController::class, 'segments']);
        Route::get('races/{race}/participant-trackers', [RaceController::class, 'participants']);
        Route::get('segment-times', [TrackingController::class, 'index']);
        Route::post('track-time', [TrackingController::class, 'store']);
        Route::delete('track-time/{id}', [TrackingController::class, 'destroy']);
        Route::post('/segments/{segment}/finish', function (Segment $segment) {
            $segment->update(['is_finished' => true]);
            return response()->json(['message' => 'Segment marked as finished']);
        });

    });


    // Logout
    Route::post('logout', [AuthController::class, 'logout']);
    Route::get('/me', [AuthController::class, 'me']);
});




