
void ponyint_cpu_throttle(uint64_t v);

void ponyint_actor_yield(pony_actor_t* actor);
void ponyint_actor_flag_gc(pony_actor_t* actor);
size_t ponyint_actor_num_messages(pony_actor_t* actor);