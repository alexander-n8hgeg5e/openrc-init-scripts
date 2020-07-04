#include <stdio.h>
#include <string.h>
#include <inttypes.h>

struct integrity_sb {
  uint8_t magic[8];               /* "integrt" */
  uint8_t version;                /* superblock version, 1 */
  int8_t log2_interleave_sectors; /* interleave sectors */
  uint16_t integrity_tag_size;    /* tag size per-sector */
  uint32_t journal_sections;      /* size of journal */
  uint64_t provided_data_sectors; /* available size for data */
  uint32_t flags;                 /* flags */
  uint8_t log2_sectors_per_block; /* presented block (sector) size */
} __attribute__ ((packed));

int main(int argc,char** argv)
{
    FILE* integrityf = NULL;
    struct integrity_sb this_sb;

    if(argc>1) {
        if(strcmp(argv[1],"-") !=0 ) {
            integrityf = fopen(argv[1],"r");
            if(!integrityf) {
                perror("fopen: ");
                return 1;
            }
        }
    }

    if(!integrityf)
        integrityf = stdin;

    fread(&this_sb,sizeof this_sb,1,integrityf);
    if(ferror(integrityf)) {
        perror("fread: ");
        return 1;
    } else
    if(feof(integrityf)) {
        printf("Short read\n");
        return 1;
    }
    if(strcmp((char*)&this_sb.magic,"integrt") != 0) {
        printf("Invalid integrity superblock\n");
        return 1;
    }
    if(this_sb.version != 1) {
        printf("Unknown integrity superblock version\n");
        return 1;
    }
    printf("Interleave sectors: %d\n",1<<this_sb.log2_interleave_sectors);
    printf("Tag size per-sector: %" PRIu16 "\n",this_sb.integrity_tag_size);
    printf("Size of journal: %" PRIu32 "\n",this_sb.journal_sections);
    printf("Available size for data: %" PRIu64 "\n",this_sb.provided_data_sectors);
    printf("Flags: 0x%" PRIx32 "\n",this_sb.flags);
    printf("Sectors per block: %u\n",1U<<this_sb.log2_sectors_per_block);
}
