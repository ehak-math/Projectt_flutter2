<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use App\Models\Participant;

class Race extends Model
{

    protected $fillable = ['name', 'start_time', 'end_time', 'status'];

    protected $casts = [
        'start_time' => 'datetime',
    ];

    public function participants()
    {
        return $this->hasMany(Participant::class);
    }

    public function segments()
    {
        return $this->hasMany(Segment::class);
    }
}

