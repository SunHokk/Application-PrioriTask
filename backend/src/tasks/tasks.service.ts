import {
  Injectable,
  NotFoundException,
  InternalServerErrorException,
} from '@nestjs/common';
import { v4 as uuidv4 } from 'uuid';
import { SupabaseService } from '../supabase/supabase.service';
import { PriorityService } from '../priorities/priority.service';
import { CreateTaskDto, UpdateTaskDto, CreateProgressUpdateDto } from './task.dto';

@Injectable()
export class TasksService {
  constructor(
    private readonly supabase: SupabaseService,
    private readonly priorityService: PriorityService,
  ) {}

  async findAll(): Promise<any[]> {
    const db = this.supabase.getClient();
    if (!db) return this._mockTasks();

    const { data, error } = await db
      .from('tasks')
      .select('*, progress_updates(*)')
      .order('created_at', { ascending: false });

    if (error) throw new InternalServerErrorException(error.message);

    // Attach priority scores
    return data.map((task) => ({
      ...task,
      priority_score: this.priorityService.calculateScore(task),
    }));
  }

  async findOne(id: string): Promise<any> {
    const db = this.supabase.getClient();
    if (!db) {
      const mocks = this._mockTasks();
      const task = mocks.find((t) => t.id === id);
      if (!task) throw new NotFoundException(`Task ${id} not found`);
      return task;
    }

    const { data, error } = await db
      .from('tasks')
      .select('*, progress_updates(*)')
      .eq('id', id)
      .single();

    if (error || !data) throw new NotFoundException(`Task ${id} not found`);

    return {
      ...data,
      priority_score: this.priorityService.calculateScore(data),
    };
  }

  async create(dto: CreateTaskDto): Promise<any> {
    const db = this.supabase.getClient();
    const newTask = {
      id: uuidv4(),
      subject_name: dto.subject_name,
      task_name: dto.task_name,
      description: dto.description ?? '',
      difficulty: dto.difficulty,
      deadline: dto.deadline,
      progress_percent: 0,
      is_completed: false,
      created_at: new Date().toISOString(),
    };

    if (!db) return { ...newTask, priority_score: 0 };

    const { data, error } = await db
      .from('tasks')
      .insert(newTask)
      .select()
      .single();

    if (error) throw new InternalServerErrorException(error.message);

    return {
      ...data,
      priority_score: this.priorityService.calculateScore(data),
    };
  }

  async update(id: string, dto: UpdateTaskDto): Promise<any> {
    const db = this.supabase.getClient();
    if (!db) throw new NotFoundException('Database not connected');

    const updates: any = {};
    if (dto.subject_name !== undefined) updates.subject_name = dto.subject_name;
    if (dto.task_name !== undefined) updates.task_name = dto.task_name;
    if (dto.description !== undefined) updates.description = dto.description;
    if (dto.difficulty !== undefined) updates.difficulty = dto.difficulty;
    if (dto.deadline !== undefined) updates.deadline = dto.deadline;
    if (dto.progress_percent !== undefined) {
      updates.progress_percent = dto.progress_percent;
      if (dto.progress_percent >= 100) updates.is_completed = true;
    }
    if (dto.is_completed !== undefined) updates.is_completed = dto.is_completed;

    const { data, error } = await db
      .from('tasks')
      .update(updates)
      .eq('id', id)
      .select()
      .single();

    if (error || !data) throw new NotFoundException(`Task ${id} not found`);

    return {
      ...data,
      priority_score: this.priorityService.calculateScore(data),
    };
  }

  async delete(id: string): Promise<void> {
    const db = this.supabase.getClient();
    if (!db) return;

    const { error } = await db.from('tasks').delete().eq('id', id);
    if (error) throw new InternalServerErrorException(error.message);
  }

  // ─── Progress Updates ───────────────────────────────────────────────────────

  async getProgressUpdates(taskId: string): Promise<any[]> {
    const db = this.supabase.getClient();
    if (!db) return [];

    const { data, error } = await db
      .from('progress_updates')
      .select('*')
      .eq('task_id', taskId)
      .order('created_at', { ascending: false });

    if (error) throw new InternalServerErrorException(error.message);
    return data;
  }

  async addProgressUpdate(
    taskId: string,
    dto: CreateProgressUpdateDto,
  ): Promise<any> {
    const db = this.supabase.getClient();

    const update = {
      id: uuidv4(),
      task_id: taskId,
      note: dto.note ?? '',
      progress_percent: dto.progress_percent,
      image_url: dto.image_url ?? null,
      created_at: new Date().toISOString(),
    };

    if (!db) return update;

    // Insert progress update
    const { data: progressData, error: progressError } = await db
      .from('progress_updates')
      .insert(update)
      .select()
      .single();

    if (progressError)
      throw new InternalServerErrorException(progressError.message);

    // Update task progress_percent
    const taskUpdates: any = { progress_percent: dto.progress_percent };
    if (dto.progress_percent >= 100) taskUpdates.is_completed = true;

    await db.from('tasks').update(taskUpdates).eq('id', taskId);

    return progressData;
  }

  // ─── Priority Score ─────────────────────────────────────────────────────────

  async getPriorityScore(taskId: string): Promise<{ score: number }> {
    const task = await this.findOne(taskId);
    const score = this.priorityService.calculateScore(task);
    return { score };
  }

  // ─── Mock data fallback (when Supabase not connected) ───────────────────────

  private _mockTasks(): any[] {
    const now = new Date();
    const addDays = (d: number) =>
      new Date(now.getTime() + d * 86400000).toISOString();

    return [
      {
        id: '1',
        subject_name: 'Kalkulus',
        task_name: 'Tugas Integral Lipat',
        description: 'Kerjakan soal integral lipat dua dan tiga dari buku',
        difficulty: 'hard',
        deadline: addDays(2),
        progress_percent: 30,
        is_completed: false,
        created_at: now.toISOString(),
        priority_score: 92.5,
        progress_updates: [],
      },
      {
        id: '2',
        subject_name: 'Pemrograman Web',
        task_name: 'Project UAS React',
        description: 'Buat aplikasi web menggunakan React',
        difficulty: 'hard',
        deadline: addDays(7),
        progress_percent: 60,
        is_completed: false,
        created_at: now.toISOString(),
        priority_score: 74.0,
        progress_updates: [],
      },
    ];
  }
}
