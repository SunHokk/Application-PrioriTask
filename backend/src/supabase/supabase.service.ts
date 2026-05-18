import { Injectable } from '@nestjs/common';
import { createClient, SupabaseClient } from '@supabase/supabase-js';

@Injectable()
export class SupabaseService {
  private client: SupabaseClient;

  constructor() {
    const url = process.env.SUPABASE_URL;
    const key = process.env.SUPABASE_SERVICE_ROLE_KEY ?? process.env.SUPABASE_ANON_KEY;

    if (!url || !key) {
      console.warn(
        'Supabase credentials not found. Running without database connection.',
      );
      return;
    }

    this.client = createClient(url, key);
  }

  getClient(): SupabaseClient {
    return this.client;
  }
}
