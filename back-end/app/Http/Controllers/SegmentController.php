<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Segment;

class SegmentController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        $segments = Segment::all();
        return response()->json($segments);
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        $data = $request->validate([
            'name' => 'required|string',
            'distance' => 'required|numeric',
            'race_id' => 'required|exists:races,id',
        ]);
        Segment::create($data);
        return response()->json([
            'message' => 'Segment created successfully',
        ], 201);
    }

    /**
     * Display the specified resource.
     */
    public function show(string $id)
    {
        $segment = Segment::find($id);
        return response()->json($segment);
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, string $id)
    {
        $segment = Segment::find($id);
        if (!$segment) {
            return response()->json([
                'message' => 'Segment not found',
            ], 404);
        }
        $data = $request->validate([
            'name' => 'required|string',
            'distance' => 'required|numeric',
            'race_id' => 'required|exists:races,id',
        ]);
        Segment::find($id)->update($data);
        return response()->json([
            'message' => 'Segment updated successfully',
        ], 200);
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(string $id)
    {
        Segment::find($id)->delete();
    }
}
