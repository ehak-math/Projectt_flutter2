<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class SegmentTime extends Model
{
    protected $fillable = ['participant_id', 'segment_id', 'time_recorded_at', 'recorded_by'];

    public function participant()
    {
        return $this->belongsTo(Participant::class);
    }

    public function segment()
    {
        return $this->belongsTo(Segment::class);
    }

    public function recorder() {
        return $this->belongsTo(User::class, 'recorded_by');
    }
}
