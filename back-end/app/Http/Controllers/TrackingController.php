<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Services\FirebaseService;
use App\Models\SegmentTime;
use App\Models\Segment;
use App\Models\Participant;


class TrackingController extends Controller
{

    public function index()
    {
        $segmentTimes = SegmentTime::with(['participant', 'segment'])->get();
        return response()->json([
            'data' => $segmentTimes
        ]);
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'participant_id' => 'required|exists:participants,id',
            'segment_id' => 'required|exists:segments,id',
            'time_recorded_at' => 'required|date',
        ]);

        $segmentTime = SegmentTime::create([
            'participant_id' => $validated['participant_id'],
            'segment_id' => $validated['segment_id'],
            'time_recorded_at' => $validated['time_recorded_at'],
            'recorded_by' => auth()->id(),
        ]);

        return response()->json([
            'message' => 'Segment time created successfully.',
            'data' => $segmentTime
        ], 201);
    }

}
