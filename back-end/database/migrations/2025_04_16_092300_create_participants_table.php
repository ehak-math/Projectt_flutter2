<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('participants', function (Blueprint $table) {
            $table->id();
            $table->string('first_name');
            $table->string('last_name');
            $table->string('bib_number')->unique(); // Unique identifier
            $table->integer('age')->nullable();
            $table->enum('gender', ['Male', 'Female', 'Other'])->nullable();
            $table->foreignId('race_id')->constrained()->onDelete('cascade');
            $table->foreignId('segment_id')->nullable()->constrained('segments')->onDelete('set null');
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('participants');
    }
};
