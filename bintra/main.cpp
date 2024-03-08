#include <QCoreApplication>

#include <elf.h>
#include <stdio.h>
#include <string.h>

#if defined(__LP64__)
#define ElfW(type) Elf64_ ## type
#else
#define ElfW(type) Elf32_ ## type
#endif

void* elf_data = nullptr;
uint32_t sec_text_offset = 0;
uint32_t exec_header_offset = 0;

bool read_elf_header(const char* elfFile) {
    // Either Elf64_Ehdr or Elf32_Ehdr depending on architecture.
//    ElfW(Ehdr) header;

    FILE* fp = fopen(elfFile, "rb");
    if (!fp)
        return false;

    fseek(fp, 0, SEEK_END);
    long size = ftell(fp);
    fseek(fp, 0, SEEK_SET);

    elf_data = malloc(size);
    fread(elf_data, 1, size, fp);
    fclose(fp);
        // read the header
    Elf32_Ehdr*  header = (Elf32_Ehdr*) elf_data;
//        fread(&header, sizeof(header), 1, file);

    // check so its really an elf file
    if (memcmp(header->e_ident, ELFMAG, SELFMAG) == 0) {
        // this is a valid elf file
        printf("Architecture = %d\n", header->e_machine);
        printf("Entry = %X\n", (uint16_t)header->e_entry);
        printf("program header entries = %X\n",
               (uint32_t)header->e_phnum);
        printf("section header entry size = %X\n",
               (uint32_t)header->e_shentsize);
        printf("section header NUM = %X\n",
               (uint32_t)header->e_shnum);
        printf("Program header table file offset = 0x%X\n",
               (uint32_t)header->e_phoff);
        printf("Section header table file offset = 0x%X\n",
               (uint32_t)header->e_shoff);
    }


    for (size_t i=0; i< header->e_phnum; i++) {
        size_t offset = i*sizeof(Elf32_Phdr);
        char* offsetptr = (char*)elf_data + header->e_phoff + offset;
        Elf32_Phdr* h = (Elf32_Phdr*) (offsetptr);
        printf("Header %u\n", i);
        printf(" is_exec %b\n", h->p_flags & PF_X);
        printf(" offset %X\n", h->p_offset);
    }


    uint32_t sec_offset = header->e_shoff;
    char* section_names = 0;
    for (size_t i=0; i<header->e_shnum; i++) {
        char* offsetptr = (char*)elf_data+sec_offset+ i*sizeof(Elf32_Shdr);
        Elf32_Shdr* sheader = (Elf32_Shdr*) (offsetptr);
        if (sheader->sh_type == SHT_STRTAB) {
            section_names = offsetptr + sizeof(Elf32_Shdr);
            section_names = (char*)elf_data + sheader->sh_offset;
            break;
        }
    }

    for (size_t i=0; i<header->e_shnum; i++) {
        Elf32_Shdr* sheader = (Elf32_Shdr*) ((char*)elf_data+sec_offset+ i*sizeof(Elf32_Shdr));
        printf("Section type = 0x%X\n",
               (uint32_t)sheader->sh_type);
        printf("Section name offset = 0x%X\n",
               (uint32_t)sheader->sh_name);
        const char* const sec_hum_name =  (char*)(section_names+(uint32_t)sheader->sh_name);
        printf("%s\n", sec_hum_name);
        if (strcmp(sec_hum_name, ".text") == 0) {
            sec_text_offset = (uint32_t)sheader->sh_offset;
            printf(".text FOUND with offset = 0x%X\n", sec_text_offset);
            break;
        }
    }
    return true;
}


void work_text_section() {
    char* code = (char*)(elf_data + sec_text_offset +sizeof(Elf32_Phdr) + sizeof(Elf32_Ehdr));
    code = (char*)(elf_data  + 0x74);
    for (int i=0; i<16; i++) {
        printf("0x%x ", 0xFF & code[i]);
    }
    printf("\n");
}

int main(int argc, char *argv[])
{
    read_elf_header("../../../default/fac2.exe");
    work_text_section();
    return 0;
}
