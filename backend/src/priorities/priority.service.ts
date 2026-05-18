import { Injectable } from '@nestjs/common';

/**
 * PrioriTask Priority Score Formula
 * ─────────────────────────────────
 * Score = (W_deadline × DeadlineFactor)
 *       + (W_difficulty × DifficultyFactor)
 *       + (W_progress × ProgressFactor)
 *
 * Weights:
 *   W_deadline   = 0.50 (highest weight – time is king)
 *   W_difficulty = 0.30
 *   W_progress   = 0.20
 *
 * DeadlineFactor (0–100):
 *   hoursLeft = hours until deadline (clamped to [0, 168])
 *   DeadlineFactor = 100 × (1 - hoursLeft / 168)
 *   → 0 h left  → factor = 100 (most urgent)
 *   → 168 h (7 days) left → factor = 0
 *   → overdue   → factor = 100 (always max urgency)
 *
 * DifficultyFactor (0–100):
 *   easy   → 33.3
 *   medium → 66.7
 *   hard   → 100
 *
 * ProgressFactor (0–100):
 *   ProgressFactor = 100 - progress_percent
 *   (less done = more urgent)
 *
 * Final score is rounded to 2 decimal places.
 */

@Injectable()
export class PriorityService {
  private readonly W_DEADLINE = 0.5;
  private readonly W_DIFFICULTY = 0.3;
  private readonly W_PROGRESS = 0.2;
  private readonly MAX_HORIZON_HOURS = 168; // 7 days

  calculateScore(task: {
    deadline: string;
    difficulty: string;
    progress_percent: number;
    is_completed: boolean;
  }): number {
    if (task.is_completed) return 0;

    const deadlineFactor = this._deadlineFactor(task.deadline);
    const difficultyFactor = this._difficultyFactor(task.difficulty);
    const progressFactor = this._progressFactor(task.progress_percent);

    const score =
      this.W_DEADLINE * deadlineFactor +
      this.W_DIFFICULTY * difficultyFactor +
      this.W_PROGRESS * progressFactor;

    return Math.round(score * 100) / 100;
  }

  private _deadlineFactor(deadlineStr: string): number {
    const now = Date.now();
    const deadline = new Date(deadlineStr).getTime();
    const hoursLeft = (deadline - now) / 3_600_000;

    if (hoursLeft <= 0) return 100; // overdue or due now

    const clamped = Math.min(hoursLeft, this.MAX_HORIZON_HOURS);
    return 100 * (1 - clamped / this.MAX_HORIZON_HOURS);
  }

  private _difficultyFactor(difficulty: string): number {
    switch (difficulty?.toLowerCase()) {
      case 'easy':
        return 33.3;
      case 'medium':
        return 66.7;
      case 'hard':
        return 100;
      default:
        return 50;
    }
  }

  private _progressFactor(progressPercent: number): number {
    const p = Math.max(0, Math.min(100, progressPercent ?? 0));
    return 100 - p;
  }

  /**
   * Rank a list of tasks by priority score descending.
   */
  rankTasks<T extends {
    deadline: string;
    difficulty: string;
    progress_percent: number;
    is_completed: boolean;
  }>(tasks: T[]): (T & { priority_score: number })[] {
    return tasks
      .map((task) => ({ ...task, priority_score: this.calculateScore(task) }))
      .sort((a, b) => b.priority_score - a.priority_score);
  }
}
