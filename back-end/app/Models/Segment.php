<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use App\Models\SegmentTime;

class Segment extends Model
{
    protected $fillable = ['name', 'distance', 'race_id'];

    public function race()
    {
        return $this->belongsTo(Race::class);
    }

    public function segmentTimes()
    {
        return $this->hasMany(SegmentTime::class);
    }
}

