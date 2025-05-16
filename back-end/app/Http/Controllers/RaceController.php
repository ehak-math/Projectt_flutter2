<?php

namespace App\Http\Controllers;

use App\Models\Race;
use Illuminate\Http\Request;
use App\Models\SegmentTime;

class RaceController extends Controller
{
    public function index()
    {
        $races = Race::with('participants')->get();

        return response()->json([
            'data' => $races
        ]);
    }

    public function show(Race $race)
    {
        $race->load('participants.segmentTimes');
        return response()->json([
            'data' => $race
        ]);
    }

    public function store(Request $request)
    {
        $data = $request->validate([
            'name' => 'required|string',
        ]);
        $race = Race::create($data);
        return response()->json([
            'message' => 'Race created successfully',
            'race' => $race
        ]);

    }

    public function segments(Race $race)
    {
        // Load segments for the given race
        $segments = $race->segments;

        return response()->json([
            'data' => $segments
        ]);
    }


    public function participants($id)
    {
        $race = Race::with('participants.segmentTimes')->findOrFail($id);

        return response()->json([
            'data' => $race->participants
        ]);
    }


    public function start(Race $race)
    {
        if ($race->status === 'Started') {
            return response()->json(['message' => 'Race has already started.'], 400);
        }

        $race->update([
            'status' => 'Started',
            'start_time' => now(),
        ]);

        return response()->json(['message' => 'Race started']);
    }

    // 🔴 FINISH the race
    public function finish(Race $race)
    {
        $totalSegments = $race->segments()->count();
        $participants = $race->participants()->with('segmentTimes')->get();

        foreach ($participants as $participant) {
            if ($participant->segmentTimes->count() < $totalSegments) {
                return response()->json([
                    'message' => 'Some participants have not completed all segments.'
                ], 400);
            }
        }

        $race->update([
            'status' => 'Finished',
            'end_time' => now(),
        ]);

        return response()->json(['message' => 'Race finished']);
    }

    // 🔄 RESET the race
    public function reset(Race $race)
    {
        // Delete all segment times for this race
        SegmentTime::whereHas('segment', function ($q) use ($race) {
            $q->where('race_id', $race->id);
        })->delete();

        // Optionally reset race status and start_time
        $race->update([
            'status' => 'Not Started',
            'start_time' => null,
        ]);

        return response()->json(['message' => 'Race reset']);
    }

    // 🏁 GET race results
    public function results(Race $race)
    {
        $participants = $race->participants()
            ->with([
                'segmentTimes.segment' => function ($q) {
                    $q->orderBy('id'); // optional for ordered results
                }
            ])
            ->get();

        return response()->json(['participants' => $participants]);
    }
}
