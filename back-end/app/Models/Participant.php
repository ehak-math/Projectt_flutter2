<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Participant extends Model
{
    protected $fillable = ['first_name', 'last_name', 'bib_number', 'age', 'gender', 'race_id', 'segment_id'];

    public function race()
    {
        return $this->belongsTo(Race::class);
    }

    public function segmentTimes()
    {
        return $this->hasMany(SegmentTime::class);
    }
    public function segment()
    {
        return $this->belongsTo(Segment::class);
    }
}

