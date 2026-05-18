import {
  Controller,
  Get,
  Post,
  Patch,
  Delete,
  Body,
  Param,
  HttpCode,
  HttpStatus,
} from '@nestjs/common';
import { TasksService } from './tasks.service';
import { CreateTaskDto, UpdateTaskDto, CreateProgressUpdateDto } from './task.dto';

@Controller('tasks')
export class TasksController {
  constructor(private readonly tasksService: TasksService) {}

  @Get()
  findAll() {
    return this.tasksService.findAll();
  }

  @Get(':id')
  findOne(@Param('id') id: string) {
    return this.tasksService.findOne(id);
  }

  @Post()
  @HttpCode(HttpStatus.CREATED)
  create(@Body() dto: CreateTaskDto) {
    return this.tasksService.create(dto);
  }

  @Patch(':id')
  update(@Param('id') id: string, @Body() dto: UpdateTaskDto) {
    return this.tasksService.update(id, dto);
  }

  @Delete(':id')
  @HttpCode(HttpStatus.NO_CONTENT)
  delete(@Param('id') id: string) {
    return this.tasksService.delete(id);
  }

  // ─── Progress Updates ───────────────────────────────────────────────────────

  @Get(':id/progress')
  getProgressUpdates(@Param('id') id: string) {
    return this.tasksService.getProgressUpdates(id);
  }

  @Post(':id/progress')
  @HttpCode(HttpStatus.CREATED)
  addProgressUpdate(
    @Param('id') id: string,
    @Body() dto: CreateProgressUpdateDto,
  ) {
    return this.tasksService.addProgressUpdate(id, dto);
  }

  // ─── Priority Score ─────────────────────────────────────────────────────────

  @Get(':id/priority')
  getPriority(@Param('id') id: string) {
    return this.tasksService.getPriorityScore(id);
  }
}
