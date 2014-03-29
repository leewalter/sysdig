#pragma once

#include "config.h"

//
// ASSERT implementation
//
#ifdef _DEBUG
#define ASSERT(X) assert(X)
#else // _DEBUG
#define ASSERT(X)
#endif // _DEBUG

//
// Capture results
//
class captureinfo
{
public:
	captureinfo()
	{
		m_nevts = 0;
		m_time = 0;
	}

	uint64_t m_nevts;
	uint64_t m_time;
};

//
// Summary table entry
//
class summary_table_entry
{
public:
	summary_table_entry(uint16_t id, bool is_unsupported_syscall)
	{
		m_id = id;
		m_ncalls = 0;
		m_is_unsupported_syscall = is_unsupported_syscall;
	}

	uint16_t m_id;
	uint64_t m_ncalls;
	bool m_is_unsupported_syscall;
};

struct summary_table_entry_rsort_comparer
{
    bool operator() (const summary_table_entry& first, const summary_table_entry& second) const 
	{
		return first.m_ncalls > second.m_ncalls;
	}
};

//
// Printer functions
//
void list_fields(bool verbose);
const char* param_type_to_string(ppm_param_type pt);
void list_events(sinsp* inspector);
void print_chisel_info(chisel_desc* cd);
void list_chisels(vector<chisel_desc>* chlist);



