<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Participant;

class ParticipantController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index(Request $request)
    {
        $query = Participant::with(['race', 'segmentTimes']);
    
        if ($request->has('race_id')) {
            $query->where('race_id', $request->input('race_id'));
        }
    
        return response()->json([
            'data' => $query->get()
        ]);
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        $data = $request->validate([
            'first_name' => 'required|string',
            'last_name' => 'required|string',
            'bib_number' => 'required|unique:participants',
            'age' => 'nullable|integer',
            'gender' => 'nullable|in:Male,Female,Other',
            'race_id' => 'required|exists:races,id',
            'segment_id' => 'nullable|exists:segments,id',
        ]);
        $participant = Participant::create($data);
        return response()->json([
            'message' => 'Participant created successfully',
            'participant' => $participant
        ]);
    }

    /**
     * Display the specified resource.
     */
    public function show(string $id)
    {
        $participant = Participant::findOrFail($id);
        return response()->json([
            'data' => $participant
        ]);
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, string $id)
    {
        $data = $request->validate([
            'first_name' => 'sometimes|string',
            'last_name' => 'sometimes|string',
            'bib_number' => 'sometimes|unique:participants,bib_number,' . $id,
            'age' => 'nullable|integer',
            'gender' => 'nullable|in:Male,Female,Other',
            'race_id' => 'sometimes|exists:races,id',
            'segment_id' => 'nullable|exists:segments,id',

        ]);
        $participant = Participant::findOrFail($id);
        $participant->update($data);
        return response()->json([
            'message' => 'Participant updated successfully',
            'participant' => $participant
        ]);
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(string $id)
    {
        $participant = Participant::findOrFail($id);
        $participant->delete();
        return response()->json([
            'message' => 'Participant deleted successfully'
        ]);
    }

    public function findByBib($bib)
    {
        $participant = Participant::where('bib_number', $bib)->first();

        if (!$participant) {
            return response()->json(['message' => 'BIB not found'], 404);
        }

        return response()->json($participant);
    }

}
